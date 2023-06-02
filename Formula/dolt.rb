class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.2.3.tar.gz"
  sha256 "284b69fa83b5207ab4a7b7fa3c3c7003b22cc6a6cfa9c49093bb7dc9d8a27c66"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "facbfc57a18a3e5f288aa2918e528796f3dd2e56a9c8a2bf08c2e4c4e50c76f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "facbfc57a18a3e5f288aa2918e528796f3dd2e56a9c8a2bf08c2e4c4e50c76f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "facbfc57a18a3e5f288aa2918e528796f3dd2e56a9c8a2bf08c2e4c4e50c76f4"
    sha256 cellar: :any_skip_relocation, ventura:        "39049d2dc4752204e1b213e6a9c318aa81f27ec4ac1c77d1d223990cc6362fd5"
    sha256 cellar: :any_skip_relocation, monterey:       "39049d2dc4752204e1b213e6a9c318aa81f27ec4ac1c77d1d223990cc6362fd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "39049d2dc4752204e1b213e6a9c318aa81f27ec4ac1c77d1d223990cc6362fd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba5ca947ef97049e171c710abfd7df034be5ee10219daf0f67109d83e1876702"
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