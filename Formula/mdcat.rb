class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/swsnr/mdcat"
  url "https://ghproxy.com/https://github.com/swsnr/mdcat/archive/refs/tags/mdcat-2.0.2.tar.gz"
  sha256 "db22edd1a05938202f67f76a65c8d298ac0a1f8ce2d8538d7a25e2591c7d7590"
  license "MPL-2.0"
  head "https://github.com/swsnr/mdcat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02e39d8691a794bd99bc6e980991a40af8e7420bc71ce75b21c48721dd6b3900"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4166cc5af32f6c6180746c1eebc62ecdd7be3a35c4c46d72a8824cb3fa25fa01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f94a0675c4455fad76b37cf1a1205cf18e89c0555d45e793bf647f74003014a"
    sha256 cellar: :any_skip_relocation, ventura:        "4f48c85f02466625c9ccbe814c3cabbfcc44105d1584bab8e08194a7b958551e"
    sha256 cellar: :any_skip_relocation, monterey:       "556004bc28d67cc0f2a5d3e873c60954496e7dc05e5e23106dbbb94c4c943ba3"
    sha256 cellar: :any_skip_relocation, big_sur:        "637462de6736dc6734ccbd146f2994484450f5e309cd89c933f528c9402faf2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cc6e21640ffcdeaed04bfa1b57ba0ef5b45f684a23dbd99ea295413fd9e15e8"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end