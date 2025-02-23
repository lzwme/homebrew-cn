class GoCamo < Formula
  desc "Secure image proxy server"
  homepage "https:github.comcactusgo-camo"
  url "https:github.comcactusgo-camoarchiverefstagsv2.6.2.tar.gz"
  sha256 "e6f9f40b0fa6facb64da754b4cdbe911ca15cc24c11e6ee94147b69fd5decd03"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa48bf376915eb45eec32f25cf472b3b1c9531586843cd78be5149873c057a99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa48bf376915eb45eec32f25cf472b3b1c9531586843cd78be5149873c057a99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa48bf376915eb45eec32f25cf472b3b1c9531586843cd78be5149873c057a99"
    sha256 cellar: :any_skip_relocation, sonoma:        "244d02672c4a359acfbade36892f1e590c8f4bbc479b1f7c1a60d8a9b8ae0222"
    sha256 cellar: :any_skip_relocation, ventura:       "244d02672c4a359acfbade36892f1e590c8f4bbc479b1f7c1a60d8a9b8ae0222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a99f7ca11775a21427d3355db4e8ed23fd933301fd5068e6c348e0991603ddc1"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "APP_VER=#{version}"
    bin.install Dir["buildbin*"]
  end

  test do
    port = free_port
    fork do
      exec bin"go-camo", "--key", "somekey", "--listen", "127.0.0.1:#{port}", "--metrics"
    end
    sleep 1
    assert_match "200 OK", shell_output("curl -sI http:localhost:#{port}metrics")

    url = "https:golang.orgdocgopherfrontpage.png"
    encoded = shell_output("#{bin}url-tool -k 'test' encode -p 'https:img.example.org' '#{url}'").chomp
    decoded = shell_output("#{bin}url-tool -k 'test' decode '#{encoded}'").chomp
    assert_equal url, decoded
  end
end