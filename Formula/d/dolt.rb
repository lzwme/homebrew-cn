class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.45.5.tar.gz"
  sha256 "dbf1d7847682d4c955282082cec0e7691a5156e21e6cf1ce19fec61241ae5002"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "261ca581eda17f4921f86169a702f5ff84f3162fccac950989f5a574ba4fd7a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c56a5135ed01d5c56c302725b110c0db625372c7d28446266b8287b5be68808"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff7c49b14994243ca1b2ab0377f206eeb072d69be1c5315da6decc5d0318c699"
    sha256 cellar: :any_skip_relocation, sonoma:        "e165d6553af9415c141aee8593f2c2ba681f3a6fa1c5d7dc7cf8b790fd406101"
    sha256 cellar: :any_skip_relocation, ventura:       "096b8e35bd73db7e0f8796e1e21022c0cdca8683a6e51ee538cd1b9790976104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f20eb25e0dc895a8522a9279abd643cf29914e3874ba27bbc35e954260e6bcc8"
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