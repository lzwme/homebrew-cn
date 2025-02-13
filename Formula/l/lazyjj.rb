class Lazyjj < Formula
  desc "TUI for Jujutsujj"
  homepage "https:github.comCretezylazyjj"
  url "https:github.comCretezylazyjjarchiverefstagsv0.4.2.tar.gz"
  sha256 "f92f084b9483e760a17807e49ad5547999074f14e62acd6ca413388a6d669f3c"
  license "Apache-2.0"
  head "https:github.comCretezylazyjj.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33c45a1f045b2643ea28557175d6df6112429c6f31a42b327f4c67203d25dcbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2232ba408f9662cda9574d9b2cd282a0eae9bc4943555a3c6f739964c1700e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "714338ac53c3342091f0b9cb5983b4ad55a9a82af4859d6b28a92b5d556b2f1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a273285b312e48b9dd65528b2a5dd532fc8770b605d5fee7881d514c58d4bd66"
    sha256 cellar: :any_skip_relocation, ventura:       "497b2af45a8ce3590723801572289b2c8c570f194ac72b0880c6473f1264a0da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42d1a54ae093c958f446553eaa9bc0e5b3bfed315266afbc164bd6d4116d99b8"
  end

  depends_on "rust" => :build
  depends_on "jj"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["LAZYJJ_LOG"] = "1"

    assert_match version.to_s, shell_output("#{bin}lazyjj --version")

    output = shell_output("#{bin}lazyjj 2>&1", 1)
    assert_match "Error: No jj repository found", output
    assert_path_exists testpath"lazyjj.log"
  end
end