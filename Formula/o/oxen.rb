class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "e6a8ff1133c6f76079defaeb922cebc95cece56e416ddf58f9b252a830da0a6d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc7c9f0a563bc8756dade384fc0bf886ada20e6e4ab0c95ca7e5b3eca0e8fd42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa197ce1290a7b97930b83c0c4bf19debc7d7daf20b4ccde814b3c04942a96ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e1bd79de37b43aca816fa594f0e2e3303e9b13e1f0d4ab040d43302a03cacd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "05660896cc536702e39fce26ec21d8d5c50e8b97bbe2ec3ba57561fe6a98dd30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "371cdaafb8c61467f2efd6100e28fb5048a68e24fb884314241be87f3ea64eda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd3380c9b9a056d5036c25b04c9383aca22833828e0752a28a5ec36304fb148a"
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