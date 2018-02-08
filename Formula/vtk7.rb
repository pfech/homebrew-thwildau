# Documentation: https://docs.brew.sh/Formula-Cookbook.html
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Vtk7 < Formula
  desc "VTK from Kitware in version 7"
  homepage "https://www.vtk.org"
  url "https://github.com/Kitware/VTK/archive/v7.1.1.tar.gz"
  sha256 "b85ad39aef10a2a383bdf09a15fe09cabd5ac5dbabf41cbeaa2dab18ab80a1b5"

  depends_on "cmake" => :build

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    args = std_cmake_args + %W[
    ]

    mkdir "build" do

      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"version.cpp").write <<-EOS
      #include <vtkVersion.h>
      #include <assert.h>
      int main(int, char *[]) {
        assert (vtkVersion::GetVTKMajorVersion()==7);
        assert (vtkVersion::GetVTKMinorVersion()==1);
        return EXIT_SUCCESS;
      }
    EOS

    system ENV.cxx, "version.cpp", "-I#{opt_include}/vtk-7.1"
    system "./a.out"
    system "#{bin}/vtkpython", "-c", "exit()"
  end
end
