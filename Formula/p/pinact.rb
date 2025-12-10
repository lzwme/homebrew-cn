class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://ghfast.top/https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "0fb097281b7e795cb38d91a3d4bc486d0176dcc766bdd5b23ae3f22b9febcb93"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "484e77447280be4c197bdf5425a90bb5442fbe6f5dbf51b70518148322ae393d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "484e77447280be4c197bdf5425a90bb5442fbe6f5dbf51b70518148322ae393d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "484e77447280be4c197bdf5425a90bb5442fbe6f5dbf51b70518148322ae393d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3153af536394e0c30cad30fe60523e7eceec5b78e8506451091a64ed7e56549"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8aaccfc30cfb5119cc2a40e8f7994eeba3e51903eab00424f7bdf73a0adae1f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d7f514dc6fd1992f20ea78d184e1726c2ae4b55c671df9a40d11fab32851bba"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pinact"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pinact --version")

    (testpath/"action.yml").write <<~YAML
      name: CI

      on: push

      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v3
            - run: npm install && npm test
    YAML

    system bin/"pinact", "run", "action.yml"

    assert_match(%r{.*?actions/checkout@[a-f0-9]{40}}, (testpath/"action.yml").read)
  end
end