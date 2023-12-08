class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/refs/tags/v1.29.1.tar.gz"
  sha256 "7a7ea3ec1b0c834e40a451c26bd332408f9e61632fb58211d90082b8daced1d7"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5d4b47e732cf1310b5092096f09163dff180c5381f7262228f674225e70f7b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57a104dadd566671fe3daae16c99ae541e67a63a51ddfb4b1d9fe126a6118e2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80eb67fada1f2978b385cea329e543832f09637afaad649b881d8638fffaa9b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "68c323a55b3bc03c0454ca3764f117002d1291807e7ab6b6f64e45f2ff248a1f"
    sha256 cellar: :any_skip_relocation, ventura:        "3ba5accb828bcf194bf2f178e28ddcfd0a0e626d633afbf6a769e7f7e201e8cc"
    sha256 cellar: :any_skip_relocation, monterey:       "c1ce3c8cabf4a4265da99c1ef1809b0a956a4a688fd5e7d8b22bc1b301624dfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ed582fd4cd4efd364654023938697f5609de2ee52ed885610cbfa4dc8b5164b"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end