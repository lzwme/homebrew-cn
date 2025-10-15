class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://ghfast.top/https://github.com/microsoft/vcpkg-tool/archive/refs/tags/2025-10-10.tar.gz"
  version "2025.10.10"
  sha256 "8117659602166c803753f2d6105c7aed842a3f06e1470e3ab3da1fedab8bda70"
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

      match[1].tr("-", ".")
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "03a78c0884f55d414f822b5f011358914651a3e063df44a6856ce343f5213ea1"
    sha256 cellar: :any,                 arm64_sequoia: "d37231e3384bd9c37aca5de43714e13b619e836c24b261ae0fd1f097f7e71c6b"
    sha256 cellar: :any,                 arm64_sonoma:  "69b07e1c9e527613a33b2d43069012d28bed0876589b4bd4b5b17d6c866430b4"
    sha256 cellar: :any,                 sonoma:        "18761209ca539d24a832101f13b9a259d25ad84f43142620d7e2f03e09266dd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20fab689130a59d1f25072a97c9332428818056712042455cb22241a87a96d72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88e7417f2fad18c2cbb44120a2ef265a6d6d894def7e5f0cddbf59ecd624e883"
  end

  depends_on "cmake" => :build
  depends_on "cmrc" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  def install
    # Improve error message when user fails to set `VCPKG_ROOT`.
    inreplace "include/vcpkg/base/message-data.inc.h",
              "If you are trying to use a copy of vcpkg that you've built, y",
              "Y"

    system "cmake", "-S", ".", "-B", "build",
                    "-DVCPKG_DEVELOPMENT_WARNINGS=OFF",
                    "-DVCPKG_BASE_VERSION=#{version.to_s.tr(".", "-")}",
                    "-DVCPKG_VERSION=#{version}",
                    "-DVCPKG_DEPENDENCY_EXTERNAL_FMT=ON",
                    "-DVCPKG_DEPENDENCY_CMAKERC=ON",
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
    output = shell_output("#{bin}/vcpkg search sqlite 2>&1", 1)
    # DO NOT CHANGE. If the test breaks then the `inreplace` needs fixing.
    # No, really, stop trying to change this.
    assert_match "You must define", output
    refute_match "copy of vcpkg that you've built", output
  end
end