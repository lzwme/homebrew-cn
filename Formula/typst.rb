class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https://github.com/typst/typst"
  url "https://ghproxy.com/https://github.com/typst/typst/archive/refs/tags/v23-03-28.tar.gz"
  version "23-03-28"
  sha256 "494b0438940a21370d31d44e090e1a6b1b3acabc8b9c4c181455f86441d5cab7"
  license "Apache-2.0"
  head "https://github.com/typst/typst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "652eb76054fa79ef230db9d0994f90b073b569b142674beb5a698ad406877602"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "836147205aed9dfe6a0f8e6f8e7dc5a4616298569056584d27d041e3e1ff7e72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fd54d96fc9452c461492785fa7aa3a2e723719e6af5bc96511a0c9d5ffb1b25"
    sha256 cellar: :any_skip_relocation, ventura:        "cf377a7f31f91827531a666c7d325abd7cce30e919f6dc2b576a51bf579f78fd"
    sha256 cellar: :any_skip_relocation, monterey:       "2eeee2b00c1563788a935e5e55f68856faf238841bb31a07bdb14942a806b4ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "a192c9970b30cad8c650bbf8e8270d8c7697238e067d666a749b21bd54b503bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ebec672c228762fae0ab2a52a32b0f551bee80382897db13a697dbb9d1b43c7"
  end

  depends_on "rust" => :build

  def install
    ENV["TYPST_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typst", testpath/"Hello.typ"

    assert_match version.to_s, shell_output("#{bin}/typst --version")
  end
end