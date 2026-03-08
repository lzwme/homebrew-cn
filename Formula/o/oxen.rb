class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "d05f553b9473f01f71b75672c90cc9f6506b4b828d298d03ae2873104b8ff62b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48490af07c83390d315c107d1ebba3c9849befcfaff50ddfe7174f43e0e4a1c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae1b027bd4190835670991b47e1cbab09669444318bec245ed38ae52e174d670"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91eda30d5afe4af8cccb872024c9dcdb93dc5d917985adb8c07f3302dfb0cbf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b52becc47f45a44ee7cdd5a9904af6f51f50519ca6e7cd18d67e5ba290cc2064"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57715352bb95593411a7cce981deab346a8038becbd1d2dd14b3a6e0ba73ac89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0912c64eb21818729bee03b6a8dad09182349e89a0879234a41b01a411aac0a"
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
    cd "oxen-rust" do
      system "cargo", "install", *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end