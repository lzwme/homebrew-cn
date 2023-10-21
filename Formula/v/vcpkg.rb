class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://ghproxy.com/https://github.com/microsoft/vcpkg-tool/archive/2023-10-18.tar.gz"
  version "2023.10.18"
  sha256 "81ed81d65ce5400667b5b59b6b280cf83bacd6822bc6eb5da8cdeabcdfa39ef5"
  license "MIT"
  head "https://github.com/microsoft/vcpkg-tool.git", branch: "main"

  # The source repository has pre-release tags with the same
  # format as the stable tags.
  livecheck do
    url :stable
    regex(/v?(\d{4}(?:[._-]\d{2}){2})/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "707fff39350a24151085a90a9d25b6a130f28d0b5dd84d7915c145c4afccf1e2"
    sha256 cellar: :any,                 arm64_ventura:  "4bc7778938041a2cb63ac40cd6827409e93832b2f4f0a6e859a39f794b28a2eb"
    sha256 cellar: :any,                 arm64_monterey: "b5eeb8ae18904b92678581d7fdf3d939412067ffe1c879d5b1ae18116c5c29c7"
    sha256 cellar: :any,                 sonoma:         "270cc5467070046284eed68b36a4434eb89ba41bb7db3faf0fe9c395cfcebe7c"
    sha256 cellar: :any,                 ventura:        "6b397206d97431addff5df92c8d884a44367e54edcb45048d95cb1a4ef3fdabf"
    sha256 cellar: :any,                 monterey:       "e390ba817cab461281fcdc37fe412fa20fc80eb9486ddb2514eb451d1bf5567b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e19aaac84db1446f07c50901bd0cdc3ce8d260be35d87213c3e57f5c43c6e39"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  fails_with gcc: "5"

  def install
    # Improve error message when user fails to set `VCPKG_ROOT`.
    inreplace "locales/messages.json" do |s|
      s.gsub! "If you are trying to use a copy of vcpkg that you've built, y", "Y"
      s.gsub! " to point to a cloned copy of https://github.com/Microsoft/vcpkg", ""
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DVCPKG_DEVELOPMENT_WARNINGS=OFF",
                    "-DVCPKG_BASE_VERSION=#{version.to_s.tr(".", "-")}",
                    "-DVCPKG_VERSION=#{version}",
                    "-DVCPKG_DEPENDENCY_EXTERNAL_FMT=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  # This is specific to the way we install only the `vcpkg` tool.
  def caveats
    <<~EOS
      This formula provides only the `vcpkg` executable. To use vcpkg:
        git clone https://github.com/microsoft/vcpkg "$HOME/vcpkg"
        export VCPKG_ROOT="$HOME/vcpkg"
    EOS
  end

  test do
    # DO NOT CHANGE. If the test breaks then the `inreplace` needs fixing.
    message = "error: Could not detect vcpkg-root."
    assert_match message, shell_output("#{bin}/vcpkg search sqlite", 1)
  end
end