class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.170.18.tar.gz"
  sha256 "3ebed22edae749a16284b0551c6dc7b3634141d815e1145a781113f60d5109e2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45629ab8ce37dbca7dc19bafcae9a11d95e038014b55cc49359ed38e84accb85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "feb6a152982fb8eb9b46ee5a66d2d467563ef56795e1d357a7647e70ef3107fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b8fe096d34f25a91d4c633b1ecad679e411216d9cb3e4da1fd885b1fb6d6b92"
    sha256 cellar: :any_skip_relocation, ventura:        "fddaddf72e5351730893d873d61e242490756da29d792ad6b9fec063d2ae4ee1"
    sha256 cellar: :any_skip_relocation, monterey:       "512275561bca473722cf3d77e961e24eb1e92a0a663981672c250a9c160bf763"
    sha256 cellar: :any_skip_relocation, big_sur:        "92bdc7a4db43a83ebe25ec2aefdae53bd6a6dbcba7be41d448c10a91656002b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eef5a4b37a243c59fa2f72a7e347c59eadbcec58bd643213223023c18cbf47b8"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin/"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    assert_match "Error: Container (document API)", shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end