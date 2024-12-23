class Nextdns < Formula
  desc "CLI for NextDNS's DNS-over-HTTPS (DoH)"
  homepage "https:nextdns.io"
  url "https:github.comnextdnsnextdnsarchiverefstagsv1.44.1.tar.gz"
  sha256 "971d3a680901b5e7243e1fd26b0424556650052fc40bb29a4ccd6e3d38a5bbbc"
  license "MIT"
  head "https:github.comnextdnsnextdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1623fb5657665f6ae78b7734b564c04ea52a9191b417f8aa9588dc0073aa16cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1623fb5657665f6ae78b7734b564c04ea52a9191b417f8aa9588dc0073aa16cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1623fb5657665f6ae78b7734b564c04ea52a9191b417f8aa9588dc0073aa16cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a326e2bd858d0b757240e6d6b6d1cbc92bcf269fb7a1271e4010dc8a3e8a840"
    sha256 cellar: :any_skip_relocation, ventura:       "2a326e2bd858d0b757240e6d6b6d1cbc92bcf269fb7a1271e4010dc8a3e8a840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a400e68abcd2ac095c2224d71e5bd77c3cfdeb90374b790f31a0a043470ec74"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output(bin"nextdns version")

    # Requires root to start
    output = if OS.mac?
      "Error: permission denied"
    else
      "Error: service nextdns start: exit status 1: nextdns: unrecognized service"
    end
    assert_match output, shell_output(bin"nextdns start 2>&1", 1)
  end
end