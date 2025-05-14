class Cot < Formula
  desc "Rust web framework for lazy developers"
  homepage "https:cot.rs"
  url "https:github.comcot-rscotarchiverefstagscot-v0.3.0.tar.gz"
  sha256 "d359d5948c0d5d8487c467a420b0b8a3b0dd8e76a4dc5b1392b21b11badf8dd4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a4ad582601b310fd2032dccd7c8cda5b35feda347b0c006fe6a85f489b04200"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07cacb84310c872b8566dd2ddd5368a5bb86107b9a42413af21ba3532cab7c20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bcc642f86d4aa89724026def2ea07b430d895debbe52b33fe206f06065fd3289"
    sha256 cellar: :any_skip_relocation, sonoma:        "327458cea9ea8a0a50e32a12d4e7c9f3670c1bf19f90f236969db25ec0b2aaa5"
    sha256 cellar: :any_skip_relocation, ventura:       "e1da2d011a0f15e92755babb6d161b480eb60d404858ab0972ecdefd62995785"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "843c192cb4f5f4045241702c2eeb9d094df3792c5699b1ba446ce5092711bd1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dc8c54af49b1b0b31391d096e5e89ce4856d680c55539838a30afc9c3cf491f"
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