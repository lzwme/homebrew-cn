class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "56df64f027be2d879fa1014c5e2bc237354227aac5da156dc7e6fe93bdb2f866"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  # The upstream repository contains tags that are not releases.
  # Limit the regex to only match version numbers.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a58e153e247339e6b971a0c5e734e71809beebeb2cd7b1ab1a7cb434212e049f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8210256947f8f7dd4d8ab995277bba274bab6341e073ab2ca0a42fa156697cb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "310310c07941c5dea9029df673ba303bcc481ba3f10b1e9cc89748866d0e8c48"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f6c3904fe3c5a166e68753d94f425ad8ac4f2813c18ae0716c6c746e247bc79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09a3b8667ed1c7bddb48ce48dafb99ef402ea8944ed0e4e66d8e49a6c34e0cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da193599ba30b8f40855de28e2162c12cee6dddb6592842881fd9b20ac881390"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end