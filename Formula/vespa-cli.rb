class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://ghproxy.com/https://github.com/vespa-engine/vespa/archive/v8.198.18.tar.gz"
  sha256 "f6d68bf6bbb3089d9ee32d2acc439b7a50ac9a99c5872d06164e4f5bcf10ae71"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)(?:-\d+)?/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a50edafd9219b352c97092094c8e6f0071ebbfeb95941a8c0d02232e90ffd8fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c241a8fef463803397d4449e9ee37ff93206b2979c173347f71671699c2871b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf6e3124dda583bb8b47c82a897047b0fc2574f5a157f42d6ed8572507dc19ac"
    sha256 cellar: :any_skip_relocation, ventura:        "57ffc154de4398e7f3c1fd5d9cdca4b80a29dec82317d407f02699a82427cc5b"
    sha256 cellar: :any_skip_relocation, monterey:       "3a3ca37f7282a3da77a8c5ddc3458efef5c480965acc92845477df181b424cfb"
    sha256 cellar: :any_skip_relocation, big_sur:        "623fbec299f476b45c70b5327f81f71139867be84e9f6e3e1fcdebe86621ce7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "578c2839e8e380ec2ef19877cfe1f71602ae7020b076a3bebdab4e2fa824389a"
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
    assert_match "Error: Get", output
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end