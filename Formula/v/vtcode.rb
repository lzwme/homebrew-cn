class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.83.0.crate"
  sha256 "575fc67a8aede0c14dfe2de1e19c6120b83249b700dfde6170fe9ae3ecd55ea8"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78b4681434a0232580ead710a638187b495b76ae83580a371644daa435280435"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d42538132eeba4944e58ff733e2d68f695abf6fdf5710456ca6d22d49ac8fae2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db5ef57b23acc1acffde987b9d72a975e888f55ef017441e667bcc7a67bb85ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "0786c021c998b7fe29dc57d4a17884a8f323c17e8160ebf994e25457b795ef55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2915b6abb30a4647a8f55aee2745023ac9ddbd44c0392e42bf540ae0cb2c3de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbcc3804e54432312c0610b6c77341b21d014eb6b0cbf9bac7122493ba378a73"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
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