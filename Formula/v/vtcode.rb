class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.74.10.crate"
  sha256 "47ac048136a8eb052a22951f91f16a03fb9663705e81a6a0d09a91f7e0a231a3"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c742eadf00f0ec89335edcbf21562644a7f140e4afd671a9497139795c43bfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bf41b6f166996698b1d8babe6e02d6e1d2d42946f06d9db149f8ad6f45a2647"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1494be683e44dc7b7ad1cbedf5b2c1969502ce08380769cb5cc7dc99677a3469"
    sha256 cellar: :any_skip_relocation, sonoma:        "0aaff478b46e66f05fdf9c67d73fcec9e1a1fecc9ef19c444fca0c39f5f7c776"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e80f251c74f34cd86d052e953e60bc4fe0d6ec7178c5a9243a0a98d6bdcc50f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55975e994b61f007ed7c436e7e1d6194f1d5403a29c5a6858d531b9919a9bb60"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end