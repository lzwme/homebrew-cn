class Swc < Formula
  desc "Super-fast Rust-based JavaScriptTypeScript compiler"
  homepage "https:swc.rs"
  url "https:github.comswc-projectswcarchiverefstagsv1.11.12.tar.gz"
  sha256 "df00bfdf76f4fa196ac6f66cf92b79b3b15ee1c703046638b826cc676361ce75"
  license "Apache-2.0"
  head "https:github.comswc-projectswc.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19a751ffae6365c300497dccf98d3f23e6d89016cd0f3b75743f1c5bda9ab01f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a894884dca8123d071e7c1e861fd8a5b728f1c852748ae71291e3aeb4ab09307"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a0fc9e66d8489b127f471dea23232439138a955447fcc07a7b2f42f75facf15"
    sha256 cellar: :any_skip_relocation, sonoma:        "e132c547c77b86614a9a31cdfc263962c52b71125944d0beabe54c496fe203a2"
    sha256 cellar: :any_skip_relocation, ventura:       "c68a90bfea5e2c75e0a8a3ed8eaf29b054cf54e3452b4615a54ec9b83d56b431"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e95aead9f6ad559e7eb17e7ab3d49fe280ff20d304b50eb11f2d48f5e1d2eb9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65b7e41046f8c5dbd257ab157e7284508c03ab292a57ea656987609e713eea29"
  end

  depends_on "rust" => :build

  def install
    # `-Zshare-generics=y` flag is only supported on nightly Rust
    rm ".cargoconfig.toml"

    system "cargo", "install", *std_cargo_args(path: "cratesswc_cli_impl")
  end

  test do
    (testpath"test.js").write <<~JS
      const x = () => 42;
    JS

    system bin"swc", "compile", "test.js", "--out-file", "test.out.js"
    assert_path_exists testpath"test.out.js"

    output = shell_output("#{bin}swc lint 2>&1", 101)
    assert_match "Lint command is not yet implemented", output
  end
end