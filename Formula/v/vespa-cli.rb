class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.387.10.tar.gz"
  sha256 "d8776a65e4fa92b348015e5bae0800f1eaac93adc0a59f1191ec653d775fc93d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81124e9e1a6414cd71b2598fb7623536fb47d95d615141be76dc1646e08b25e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09c6b6df094743606f4682b66f04b6f56b4cdcb0a7b489a6f77b4f3ae9ef6be9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ef02e23a8427339e55d88e0765585fc14d6bfeef628a28dc1c49bb8da74a71c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a86ca9e09fb0e0271e48860a06b4d6b726a3a4e6eed285ea4ff37dbe98560c8a"
    sha256 cellar: :any_skip_relocation, ventura:        "8247a0007c95d8d984533ce8711d8c5bb8f432d7d65f960e821dc01b85b8f295"
    sha256 cellar: :any_skip_relocation, monterey:       "0ec2330ae8be4de0eb581fc31f9edbf9a5c5e80aede2e171ea74179c4af313cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da50eb45df7a6c8b5c14271be2246e159ea94d6e710c2f99e92fd4f84fd3a9c4"
  end

  depends_on "go" => :build

  def install
    cd "clientgo" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system bin"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}vespa config get target")
  end
end