class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.38.0.tar.gz"
  sha256 "b5d20c7f10d3c4089ce3151532665ac2cb47c8bfc19e81fdbe0bfb6ed39ef6b2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ca980fadf56361274fb2b58a50a871d7ccd544dbbf188753aec4f7477c294c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d4129bff77812a44694d7deba9712df05351c8c2fe92cea62fccaad9de005cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6904ed7d149d26e2e41443506cbed6e4c0f3a4894ed306746c1fdaf7d6ac276f"
    sha256 cellar: :any_skip_relocation, sonoma:         "74c9818839fb22d111a7618bb29ade37ebb102101317a2a844c801762f66462b"
    sha256 cellar: :any_skip_relocation, ventura:        "a984f565bf592db7a32544ef32d511ba3d0dad7afe1a455d8e3d866402a8973c"
    sha256 cellar: :any_skip_relocation, monterey:       "875c7014b402f23275497ddea451233e2e99e3ad3707e8f847d08da4a1b1d95f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af249cb96db8eba27897af7a13877c0050fb3ea1a56bbc83cbd81aa10f3a38a7"
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