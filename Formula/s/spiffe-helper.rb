class SpiffeHelper < Formula
  desc "Tool that can be used to retrieve and manage SVIDs on behalf of a workload"
  homepage "https://github.com/spiffe/spiffe-helper"
  url "https://ghfast.top/https://github.com/spiffe/spiffe-helper/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "f764d5ca5a76294bbaa54ae600970da57e231521debd889e3ae58df78516506d"
  license "Apache-2.0"
  head "https://github.com/spiffe/spiffe-helper.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "29ec768ad9f6ea8cda6c031ed59a9f50d7732759068e3e06dca1b4520535e428"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "29ec768ad9f6ea8cda6c031ed59a9f50d7732759068e3e06dca1b4520535e428"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "29ec768ad9f6ea8cda6c031ed59a9f50d7732759068e3e06dca1b4520535e428"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2286b5e6badbe348f2b6e9264cfb30d12301c9bbe83c372259f070022cc06194"
    sha256 cellar: :any,                 x86_64_linux:      "9e74a289fe8179c655b2fa30b16722b62aae983a4e544fd432c74912214a2f6f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/spiffe/spiffe-helper/pkg/version.gittag=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/spiffe-helper"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spiffe-helper -version")

    output = shell_output("#{bin}/spiffe-helper 2>&1", 1)
    assert_match "helper.conf: no such file or directory", output
  end
end