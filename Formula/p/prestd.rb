class Prestd < Formula
  desc "Simplify and accelerate development on any Postgres application, existing or new"
  homepage "https:github.comprestprest"
  url "https:github.comprestprestarchiverefstagsv1.5.1.tar.gz"
  sha256 "c766aabfa2c395db136e8c4423fe9963dfbbf706dd043e560775dec5b5988993"
  license "MIT"
  head "https:github.comprestprest.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24c720b5256bbe2a1a426165dfcf560ae72b82ee28a4369e705ae86585215c5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7afc2cd350764be9c0b1b0748550d806fa77b464d6f6521aec5c6856385bba9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa6d3fb9ee2b5e7a8c85538270e58f9c7e856f27f206c748c23026b8318259c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "df0e71e53bb5b5a5b6730a5653e04ea5776d4acac563a7b3625b0559412c793f"
    sha256 cellar: :any_skip_relocation, ventura:        "6beccd51cc2607be3e88f73e1ab49c50ef982086efc3c068e1a9e597c307cea5"
    sha256 cellar: :any_skip_relocation, monterey:       "822e6e048b649bea1d6d0dc722477f4e7ebe9abc6d83acf4b751559197a78fb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50b3e6bfdfd42443b050bdc51057843a25207b3f6d669a1a282c482561440365"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comprestpresthelpers.PrestVersionNumber=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdprestd"
  end

  test do
    (testpath"prest.toml").write <<~EOS
      [jwt]
      default = false

      [pg]
      host = "127.0.0.1"
      user = "prest"
      pass = "prest"
      port = 5432
      database = "prest"
    EOS

    output = shell_output("#{bin}prestd migrate up --path .", 255)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}prestd version")
  end
end