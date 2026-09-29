class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://ghfast.top/https://github.com/microsoft/vcpkg-tool/archive/refs/tags/2026-09-26.tar.gz"
  sha256 "05d11adc0bfc5e4d0a9d559e8f98a70222e1ff06f2ce866b0a4c690c41b6a5f5"
  license "MIT"
  head "https://github.com/microsoft/vcpkg-tool.git", branch: "main"

  # The source repository has pre-release tags with the same
  # format as the stable tags.
  livecheck do
    url :stable
    regex(/v?(\d{4}(?:[._-]\d{2}){2})/i)
    strategy :github_latest do |json, regex|
      match = json["tag_name"]&.match(regex)
      next if match.blank?

      match[1]
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2e578b82d9784a741f3b3a5c6ce3924c926d6ea7508d8f5928ad2f59fe969b77"
    sha256 cellar: :any, arm64_tahoe:       "55a0cc8ea358b474f509b75b46fdd8a5caab6390a06bed93ba86721d2a96367b"
    sha256 cellar: :any, arm64_sequoia:     "770cfeb78b316d82a9f81c1fcbd50c6d0df6fa4af7191c962c1af77af5c2dfc7"
    sha256 cellar: :any, arm64_linux:       "5bed1f759770f8383fd0118de55fb0b3321a9cd616f8d83cc48567fd2bc55677"
    sha256 cellar: :any, x86_64_linux:      "7f5c050ecf80307ef3da472e06ed8bbd1b6d2d9efc0022fd1616ec7827c3a16c"
  end

  depends_on "cmake" => :build
  depends_on "cmrc" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  uses_from_macos "curl"

  def install
    # Improve error message when user fails to set `VCPKG_ROOT`.
    inreplace "include/vcpkg/base/message-data.inc.h",
              "If you are trying to use a copy of vcpkg that you've built, y",
              "Y"

    # GCC 12 may vectorize SHA code into unsupported `eor3` instructions on
    # Linux arm64 builders.
    ENV.append "CXXFLAGS", "-fno-tree-vectorize" if OS.linux? && Hardware::CPU.arm?

    # VCPKG_VERSION is used by upstream for setting the commit hash
    args = %W[
      -DVCPKG_DEVELOPMENT_WARNINGS=OFF
      -DVCPKG_BASE_VERSION=#{version}
      -DVCPKG_VERSION=#{tap.user}
      -DVCPKG_LIBCURL_DLSYM=OFF
      -DVCPKG_DEPENDENCY_EXTERNAL_FMT=ON
      -DVCPKG_DEPENDENCY_CMAKERC=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
    assert_match version.to_s, shell_output("#{bin}/vcpkg --version")
    output = shell_output("#{bin}/vcpkg search sqlite 2>&1", 1)
    # DO NOT CHANGE. If the test breaks then the `inreplace` needs fixing.
    # No, really, stop trying to change this.
    assert_match "You must define", output
    refute_match "copy of vcpkg that you've built", output
  end
end