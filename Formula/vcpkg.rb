class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://ghproxy.com/https://github.com/microsoft/vcpkg-tool/archive/2023-08-02.tar.gz"
  version "2023.08.02"
  sha256 "b36d3b458b7eedc69ed9d6ede01aea00cb6e95bf64bf53a263474cf13849a87e"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a249b113763bafeb70b8f7cf44d892c029921d00b6d09b8e68389df95b8dfc42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1d7e8af71022e353835925b95b59db64216cd370ab34899751a7b350a0c70b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb4100eed8966b43d29100417ed2c7747212459214e10c5e15a95c4cebf45d39"
    sha256 cellar: :any_skip_relocation, ventura:        "158de316c80c54acd00dd15ea1683ebb0029ee9c668695315c97a09f74e77c1c"
    sha256 cellar: :any_skip_relocation, monterey:       "053741306dee81b7e7130cd9ecd02c924e3b2abf8239af8551f4594b14305246"
    sha256 cellar: :any_skip_relocation, big_sur:        "56c3fff1a5cea2419ba1f1b9cf1d429743ae84da32cca47968742a52668401e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "881ee6a543bbaff9ca4e0cdcf9beab6b0617aa4eb9092f34e3ae80a30518a686"
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