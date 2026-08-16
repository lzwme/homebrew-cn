class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.146.0.crate"
  sha256 "e44eeb952feebce3974a45779631d43ff843acfe73b6c3231182a324c59200a1"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "432afd27a735901c60a5eb66842a97dd89023eaaecbf539411313db300b004b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e49a21da8a3b0f78141e127ae643a2ee2eac31ff05fe33c9ce7ac6e7b95d652"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9585bc7f1ac81b46697f0b8a6f93beb647fc8cbc7b8fc2b220b8d5e39201d651"
    sha256 cellar: :any_skip_relocation, sonoma:        "30842120dbaaa5a793b5c555f427d81c93805207702bf29ad6edd985edf0548b"
    sha256 cellar: :any,                 arm64_linux:   "878d0be6aaeadf4b790ed3eb774cb8b70d45f38343edf2a2bb7ae7e3d08ab23a"
    sha256 cellar: :any,                 x86_64_linux:  "c5413f00f7ef8102fc93fb8cbf7076148e535afcfe81e9b0e7a3938c1eb73b5b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "OPENAI", output
  end
end