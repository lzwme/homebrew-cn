class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.43.1.tar.gz"
  sha256 "dcb7881c38529aa27494e104c7f9bc393f5418f349af7e801ebcbc36cdaa04ab"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "920909ad5ccb60d8ea90a62d04af0df06515f62fa3313cc56d71dfe5a25ecbc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3793c35ade789e2635c684b338161221e634bd1beb3b6b212abfa03ccb8625aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa8a4f4ddb0bfeb9b56aaa97ef227ff80a17aaf706fb9404956818a54a2e775e"
    sha256 cellar: :any_skip_relocation, sonoma:        "78f4b041a30b3065351a3590dfad57ee16b085cfe1511dc4cc66710303911ada"
    sha256 cellar: :any_skip_relocation, ventura:       "f9731f6b0fe51d5bbfa70d1a868707e916b94480c5f9f70ef9fc117a8b1b71b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1133af55da8781b915e6d77dcf06f13947a493bcc9c8bb369bab0f944e5bae9"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmddolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin"dolt", "init", "--name", "test", "--email", "test"
      system bin"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}dolt sql -q 'show tables'")
    end
  end
end