class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.43.1.tar.gz"
  sha256 "264bd008619d3094135dabfaac595035e762e217ebd135c8fedd5471349b5667"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99e10e53ae69bda93be2f9601dff1789ae917cbac452f5d9901595e8a3565e26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55dbc6b9815b04d717e934b6ddf1a03ef5c148d005a14ae064ab6ac13e4bbaf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd11bb9b2180d15c3216e68495fca1a46ab338a630078b4b867ef0b13a60e09a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf75eb72f4e81f2110dd43d15a2627874d12678a347e90e78588d655286ceef5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9e2cdfa6e5c243a72a6bccd85955b687842565cbfc2aa629faa1e3a786ad02c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f52a79c4c4371cf154eec56aafc3bec56735adf99953cd6d269cca2b7f199e91"
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