class Cot < Formula
  desc "Rust web framework for lazy developers"
  homepage "https:cot.rs"
  url "https:github.comcot-rscotarchiverefstagscot-v0.2.1.tar.gz"
  sha256 "9f03ade1ea828cc3313627985e502eef307562d72133401f29fb1c3c0b2c4956"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25f5f794938544ba6f5bb0b5d3203d325ee41faa682511d562270395ed7c6238"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c85d9d061142dd6a3eb4eff8627a9253a1856eb469de89184d7f0b122d1ca131"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d35fe7d7ecba6a9ecdc382612b98e6387ee4a1a96d7780579e641e75719daf2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4a950becbaaa004b8b3e83cd6467bd0887c059eb82b69f7fa29ae2e1ee0294b"
    sha256 cellar: :any_skip_relocation, ventura:       "62fb57c1590f3b78a588291965dc827b736f79808adc0fabb1b8bf33b2f50320"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7689864647ff345eabffbd9f42be08939e1c29a43c80e0c9d681be6e06b491c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10d3f311a1737328dda6a0170c3c1ad4687139614c5bc3162aff17c362b1d7e2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cot-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cot --version")

    system bin"cot", "new", "test-project"
    assert_path_exists testpath"test-projectCargo.toml"
  end
end