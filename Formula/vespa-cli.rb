class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.162.29.tar.gz"
  sha256 "ad73cc219f0c0decb0208a18b03c1655c3af2844ccfb29fa4dadfc17d1e7191e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48decfb18cde1c060b828d02be7051d906b8eabbf8a35147bf74ad99512dc560"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2d6853bbb2c6c3430b8546c81094a4b90354cb8cf71d078849517825c617c33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92f16e06a699ff32a0e8ef851fe426689f6da86c68271fe69373347f77eb05e0"
    sha256 cellar: :any_skip_relocation, ventura:        "1e6ccf2cb0fc8492b8a66ee013342b2408256c67d8a3af257b083900a51808cb"
    sha256 cellar: :any_skip_relocation, monterey:       "1234cddf315570f4c3487f08becd4ecdcb93dc5461d0aebe280e853b33f7f666"
    sha256 cellar: :any_skip_relocation, big_sur:        "81601c4d843269feed89531b3cf716862a9d9db3ae4d8f4a08f200bad1b5a068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0840fd623b8e61711400dcab5c5aeeddcc0bbd6842dfed773bc71c4bd302f3ef"
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
    assert_match "Error: Request failed", shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end