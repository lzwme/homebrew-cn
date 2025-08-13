class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://ghfast.top/https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "21ee79849a51ee570bba14f6c9a930dfbb8704b54d29e6193e4079fe2bb96b0f"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a3ca91c7860d29bb30a9cbf0bd7760e7790fc5b6fdd84ccaa5dd16a6dbcdf03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a3ca91c7860d29bb30a9cbf0bd7760e7790fc5b6fdd84ccaa5dd16a6dbcdf03"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a3ca91c7860d29bb30a9cbf0bd7760e7790fc5b6fdd84ccaa5dd16a6dbcdf03"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f536460499aab1b38b76d5a2691e3b8a7b3ede8c97af40a2115f3c25e227130"
    sha256 cellar: :any_skip_relocation, ventura:       "2f536460499aab1b38b76d5a2691e3b8a7b3ede8c97af40a2115f3c25e227130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b2d694ad8402e580424cf6fad2e442d321d9c72a3983c1d058c933a5c3bcede"
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