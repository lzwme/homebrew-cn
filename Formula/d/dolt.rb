class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.13.4.tar.gz"
  sha256 "68480840875b18c5c8c07a237d301d524388488f2706d7a9e70259ad27b4d5f5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bf3262cb411eede4783d722d980ccd09e566cd032fefe58a0df89a2db6450fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b69a1ec6d10be0870a08534dd480a797403789020e84626a39fce187cf3bcb3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d93559fe228de2f53b5b1257036436eebc0b9f22b8969c110b0500ba27cd703c"
    sha256 cellar: :any_skip_relocation, ventura:        "4a46156a6f59b075ef6b168fcae8667a717362bff32d95114aca37681bdf6c0c"
    sha256 cellar: :any_skip_relocation, monterey:       "788ba1f7f39aa72516e776c1dc0f0761ccd7cab47e93014973c755f7c7cfdedd"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3b33cf996f1a6e58486f59f18476ef74bbd56522f4f26e27933836f1488cd18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23849ebe6cfafaccf7165550d344b2326b88cb42f8688a66bbf0af7c57fd0912"
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