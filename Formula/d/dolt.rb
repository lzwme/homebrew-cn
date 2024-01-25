class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.32.2.tar.gz"
  sha256 "7927b26f9b3a48fba832c3a951a8b064b16540fbba25b03ed42e97fb285aa517"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b2121dabf994b553752be48f2c66f9f3bdadc09d8417847feb0592bfe43e8bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e6729a30d8b61e0812dfd4f5183c2991b64caddc5624fc9580f7628cdeaaece"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4f71540802703c32456c92d76f01c748ba5379fbdfab8d72c9aa7dc82a39d09"
    sha256 cellar: :any_skip_relocation, sonoma:         "390ff9d2e535bdf84b98fa59b38edc1f4155817d2553d6a03374899229814486"
    sha256 cellar: :any_skip_relocation, ventura:        "aaeba6082494114ae4f125f26b25cb59de05c3b3e477337867565719a5603868"
    sha256 cellar: :any_skip_relocation, monterey:       "f4a55f3ceadcc12b86e5a49fe64e1e220c58fc9cd6c14ad7cf9ef7a7a7492521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9c0a23aa6094de2f2e5e087815c9e5549c5171ad77e1848e071920e74285bbc"
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