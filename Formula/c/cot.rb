class Cot < Formula
  desc "Rust web framework for lazy developers"
  homepage "https:cot.rs"
  url "https:github.comcot-rscotarchiverefstagscot-v0.1.3.tar.gz"
  sha256 "ad38068f4ac58a36e0e0c9ca650ff5d7472afeb5ec97ca609d5ad0a0df1c0c8d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1300d02137944bcd1b61afb358e0fd44007ca45e55d3d854bc064531a5655e67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1e1e916ff4436ce79d0ee61fa12874fa332791a883b89d6dc8b811fae7902f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6830528942b4964b5dcce12d0c5d51c640d5c1e1fe28eed683e0ee4ceb6dc79f"
    sha256 cellar: :any_skip_relocation, sonoma:        "44e480946202dd3bc6dae40963ccb231a4c2100b94463acd12a06b4599fb6889"
    sha256 cellar: :any_skip_relocation, ventura:       "d3ce15292bbeea41f9ce1f068921328262f303b528af08b2e435b29e25c80bc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5e4f196e4514b42109217115e8e353a72c46de7da542926adbf41575e69b6e1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cot-cli")
  end

  test do
    assert_match "cot-cli #{version}", shell_output("#{bin}cot --version")

    system bin"cot", "new", "test-project"
    assert_path_exists testpath"test-projectCargo.toml"
  end
end