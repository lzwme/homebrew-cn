class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.215.17.tar.gz"
  sha256 "22d527e1e6b3c71a0988a0c01907c17c1ef871b48639eddcb1f981d17ee3d3d3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "017481662bf00c26c0b1e2142eea75209ce945c95afaaa28861fd958c8d08846"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c860c19088698c2f711e51bdf0c9c853bcb3db433a57f3cd563204d5fff8e65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbf95591bb6e550e7f62a9573c2ba975f3e9d0ec883efdd934f26e8a690b7d59"
    sha256 cellar: :any_skip_relocation, ventura:        "43948be6653f8003768396eb711e5afc427ec7654a62de8f1b6fd6554d57f9dd"
    sha256 cellar: :any_skip_relocation, monterey:       "45e8351e7941c101fb3ba60027898e79d7cf7131823d64580337a157919eb542"
    sha256 cellar: :any_skip_relocation, big_sur:        "b562e2b9c926283a3bf7857256263e8932aceb9347a3dfee44f626935c1441fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "553d7c1a70eb3ee322ee65093df9093740eec551c7a1fab3fd5540a9ca4003fc"
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
    output = shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged after waiting 0s", output
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end