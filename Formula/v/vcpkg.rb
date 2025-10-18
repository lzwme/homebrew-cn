class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://ghfast.top/https://github.com/microsoft/vcpkg-tool/archive/refs/tags/2025-10-16.tar.gz"
  version "2025.10.16"
  sha256 "70c25e3c3653e917c8d776c90b35b55490152bec36b8be87ca88491697fde3ef"
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
    sha256 cellar: :any,                 arm64_tahoe:   "6abe5ceeb2c07c55b24eb69e37c5b9fc8ddb42e6a0bbd8e488dcde197f1abff5"
    sha256 cellar: :any,                 arm64_sequoia: "78478a9c84e383b830e003fd4eb9b9c79c051ca49d4591c157c3acd052dcec21"
    sha256 cellar: :any,                 arm64_sonoma:  "5960f9aa047c0b915559920dd85db452ea5033ea1bb90e8405bd2bd79971d9f9"
    sha256 cellar: :any,                 sonoma:        "6dda75870ecf3da8469e036d0412f3b576a8a87e06937c49d60817fc1029d45c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed6320c230a3a2f3779c23ed4c854d40e312145a59286f72bc3ed30a58c21e91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32dad771a326241e768a5cd7c788d43e3c4566e5cceff3a5afd793880b7254af"
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