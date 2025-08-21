class Cariddi < Formula
  desc "Scan for endpoints, secrets, API keys, file extensions, tokens and more"
  homepage "https://github.com/edoardottt/cariddi"
  url "https://ghfast.top/https://github.com/edoardottt/cariddi/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "a73ad142a4456ab238556d9df594470902bf799826dedc9ff074c9edb5c72e8d"
  license "GPL-3.0-or-later"
  head "https://github.com/edoardottt/cariddi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66a62b9a30d4a2c097af0a9d4e09d799a2852d3050cdb20405568a3cee21feca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66a62b9a30d4a2c097af0a9d4e09d799a2852d3050cdb20405568a3cee21feca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66a62b9a30d4a2c097af0a9d4e09d799a2852d3050cdb20405568a3cee21feca"
    sha256 cellar: :any_skip_relocation, sonoma:        "e51c6c38289df53c451192e0a23221746a1d67c6cd2ca0aeec490307513ce406"
    sha256 cellar: :any_skip_relocation, ventura:       "e51c6c38289df53c451192e0a23221746a1d67c6cd2ca0aeec490307513ce406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4da0a413667289c3fd32765d92e78719d8a78c7ced6bf662b88a8de99754dae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cariddi"
  end

  test do
    output = pipe_output(bin/"cariddi", "http://testphp.vulnweb.com")
    assert_match "http://testphp.vulnweb.com/login.php", output

    assert_match version.to_s, shell_output("#{bin}/cariddi -version 2>&1")
  end
end