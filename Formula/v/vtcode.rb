class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.117.0.crate"
  sha256 "78d9c735c82a812ca8973f74f10c0f87e128db78fa48091e510fd5274acba428"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2575911d81ccb8334ad772e10ba371279c0377f3f6e2a0f8cc044fef46adfec1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd3412a58f481d18d4b3b351116acbb85429124d6a3e57abd6496dbf71144314"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c734dfbc3a5d85e2726ac2dfa9d00b2b655b2384cb832e7b2093d2f2c190211"
    sha256 cellar: :any_skip_relocation, sonoma:        "62362cc3cd9c97191f8138d2e68887023284084e2866136ed8cd5c6a61d2b714"
    sha256 cellar: :any,                 arm64_linux:   "4a882d20e4df610aa2f7803bfe64977c9b1a7db875d66b7b175361b55f14f284"
    sha256 cellar: :any,                 x86_64_linux:  "f40db3c34c23bd1e9a06d4a24ab7def07eb6755609c939298a553c3eabd3c543"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "gpt-5", output
  end
end