class Cfssl < Formula
  desc "CloudFlare's PKI toolkit"
  homepage "https://cfssl.org/"
  url "https://ghfast.top/https://github.com/cloudflare/cfssl/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "8ab0c1a01f89efd9265a12bd0500beffbd520bacbee02a4476a4f5122fe49ae2"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/cfssl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0e76475429201c1d5c20915ce0c02819e4ea8ee087da5a7e977edcada59774c4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c597439c2bb91e0c0fbda5f28d36f67cb286dd76109eba5bfb92802b66a17da7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "717813922f45c003303213d540f8b555c94cfcf2ddb419e99a8f7efaafdf2a5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "21195c91db34dc0cc0ee3ac0461aeea57160275bf5a14f8cb11bdf1d2166a317"
    sha256 cellar: :any,                 x86_64_linux:      "2fe5e651b4627656e89f138d6002f82bdb70e247299f65008b96ba9150370d7c"
  end

  depends_on "go" => :build
  depends_on "libtool"

  deny_network_access!

  def install
    ldflags = "-X github.com/cloudflare/cfssl/cli/version.version=#{version}"

    (buildpath/"cmd").each_child(false) do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: bin/cmd), "./cmd/#{cmd}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cfssl version")
    assert_match version.to_s, shell_output("#{bin}/cfssljson --version")

    (testpath/"request.json").write <<~JSON
      {
        "CN" : "Your Certificate Authority",
        "hosts" : [],
        "key" : {
          "algo" : "rsa",
          "size" : 4096
        },
        "names" : [
          {
            "C" : "US",
            "ST" : "Your State",
            "L" : "Your City",
            "O" : "Your Organization",
            "OU" : "Your Certificate Authority"
          }
        ]
      }
    JSON
    response_json = shell_output("#{bin}/cfssl genkey -initca request.json")
    response = JSON.parse(response_json)
    assert_match(/^-----BEGIN CERTIFICATE-----.*/, response["cert"])
    assert_match(/.*-----END CERTIFICATE-----$/, response["cert"])
    assert_match(/^-----BEGIN RSA PRIVATE KEY-----.*/, response["key"])
    assert_match(/.*-----END RSA PRIVATE KEY-----$/, response["key"])
  end
end