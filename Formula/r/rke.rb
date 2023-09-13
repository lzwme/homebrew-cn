class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://ghproxy.com/https://github.com/rancher/rke/archive/v1.4.9.tar.gz"
  sha256 "716a9137e5d93393c60968eab5dbf405e49109d65533b29ec2e3634252793a97"
  license "Apache-2.0"

  # It's necessary to check releases instead of tags here (to avoid upstream
  # tag issues) but we can't use the `GithubLatest` strategy because upstream
  # creates releases for more than one minor version (i.e., the "latest" release
  # isn't the newest version at times).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78eba2ee9931b45dd173fc363d24a828034c49cc9de07040f54b4cd0045aae88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e7f58b7d5a05d71f14802bb0f9ed150653f4aa0101574aaa70733f1de5da769"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcacf805f8e9f936ff839c44ad93543004956fbc8bbd05c117cffcc1c9ad6465"
    sha256 cellar: :any_skip_relocation, ventura:        "440a0705cc8f161a62a5c11b9a29ddf06d07c80f76f5a1cfb79d0b4b2e8d4c00"
    sha256 cellar: :any_skip_relocation, monterey:       "e89d9b29e0d7b226c1310307a972d8bc5f7c12d997105a6ac312654599a76d69"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c2440affeaccaf311d7d050fed07485f5ff7304656ae6566947b8abe43c7bd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d4df0ebe8c31e0fc2ec20551bedeb36f997b26c833c69474f34185be24e177c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.VERSION=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"rke", "config", "-e"
    assert_predicate testpath/"cluster.yml", :exist?
  end
end