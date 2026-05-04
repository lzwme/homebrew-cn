class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.48.3.tar.gz"
  sha256 "0f2744a76d9378e5f6953939e3b3ed9fdbd57cbf5cf396692f94b521f2e4c84b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "954bf5473f44fce4e0d03bc2a52fe7d5b28817ad2c1ac31d06b85d74a2ea6d47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de9146418bd6342a26272317da8925d84d86040ad20564f9b41a8f668859a02e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eeee5c68da8a0fcc6292da13e59aa5d71121be5defc47f8635e5da0e7a768d1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d00637360caaafaa9bda1537567b01074c729beedfd15a1867068aff81727b4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31695d1a27fa8f81cbcfae848777d122c78c250cb355122b27fc32d346bdf247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0371977832feb2c94a90cb90cd024a9087ae3db782061c6c11e4595ed638b1d0"
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