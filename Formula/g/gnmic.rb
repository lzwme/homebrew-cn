class Gnmic < Formula
  desc "GNMI CLI client and collector"
  homepage "https:gnmic.openconfig.net"
  url "https:github.comopenconfiggnmicarchiverefstagsv0.38.0.tar.gz"
  sha256 "1ff2d83aad75b67d274dee0fe916521c40d542e24733360e7cde1407be36dc6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "583af194423157eed80ae0d5769d05f34e574b951cde136cbf012dd1129a4d83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46d9d85314f13542f884daa692d0f7ca175bdd52646ff3951f7e0cb73c2dbdc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c67b4ca731a8f4a4f87d25a8e2bac4acb373903ffdc0be9ca6ea2614cce9b0a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "53fa245c80a85d024bf69aa0a51ee99aed53f7d981fb33324184966cf5cd866a"
    sha256 cellar: :any_skip_relocation, ventura:        "6b29fd543887c053a811f147018524a336f710dd85c68dd8b195894c975cddb3"
    sha256 cellar: :any_skip_relocation, monterey:       "b4ad5b81402af31e31a128eca686d9dcfa8af7a50355e48354bcb491a68dc154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd650f680597569767853fc1719f6c88357c2dfc10a91d21fe12ee3f23141dc9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comopenconfiggnmicpkgapp.version=#{version}
      -X github.comopenconfiggnmicpkgapp.commit=#{tap.user}
      -X github.comopenconfiggnmicpkgapp.date=#{time.iso8601}
      -X github.comopenconfiggnmicpkgapp.gitURL=https:github.comopenconfiggnmic
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"gnmic", "completion")
  end

  test do
    connection_output = shell_output(bin"gnmic -u gnmi -p dummy --skip-verify --timeout 1s -a 127.0.0.1:0 " \
                                         "capabilities 2>&1", 1)
    assert_match "target \"127.0.0.1:0\", capabilities request failed: failed to create a gRPC client for " \
                 "target \"127.0.0.1:0\" : 127.0.0.1:0: context deadline exceeded", connection_output

    assert_match version.to_s, shell_output("#{bin}gnmic version")
  end
end