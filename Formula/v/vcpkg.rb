class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://ghproxy.com/https://github.com/microsoft/vcpkg-tool/archive/refs/tags/2023-11-16.tar.gz"
  version "2023.11.16"
  sha256 "9ed144f6836bb608c10f4facfed39c2caf3ceee9f2d9543f304568c46825c03f"
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
    sha256 cellar: :any,                 arm64_sonoma:   "5d5050f091d9e0ea8347a4f615f3546076e5ab6edc3e998ade1af57855973e53"
    sha256 cellar: :any,                 arm64_ventura:  "38e486a5680b55fc6ea0b15472d394691d2c9972e1c089e5b84c34d0643b3eb4"
    sha256 cellar: :any,                 arm64_monterey: "99c72fb9b4cd3401e0e00aacb30ba6132b72e1f970dd12ec14624f95b761411e"
    sha256 cellar: :any,                 sonoma:         "e74a4f9dea17f83dc81d4576779174b193b84580af5d732cc021f99b3e950589"
    sha256 cellar: :any,                 ventura:        "f02bc8fb5189b1f24e5e178b398a2628f05f57e95141f1f4f6d535d6984a3f52"
    sha256 cellar: :any,                 monterey:       "0db6e0080ef96aceada052926056459f7c0dbc9de73421936f1bd12241e39d3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0b8a729efdcef9a86b477e67dab52ab4bc25576056b0139f907508ad375478e"
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