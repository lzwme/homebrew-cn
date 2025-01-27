class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https:popeyecli.io"
  url "https:github.comderailedpopeyearchiverefstagsv0.22.0.tar.gz"
  sha256 "eb6fb55174b0ca27d32bc7287fc1e091f5ef50fde339fe0a07832832b0302477"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c37a28f21ff71320b8fef8e85fb3fc7d614295579de22e35388eb007d0a869af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0533f002adfb8886b49f70e53c1068538d99b6ccbcd27064ce5162d8e141269"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "903f30109144cb269bfc1d1a332f8d1eeca4dcece0fa57eaa561e858dde1e638"
    sha256 cellar: :any_skip_relocation, sonoma:        "2395b2de111f001d63822c8fac2b98236fe1ec0ff42517cbf85d9910c5d0a56b"
    sha256 cellar: :any_skip_relocation, ventura:       "4de272e87f5c33e8fbc030064ff4316cd17efcc534160ff755448d50005821de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91e0a44530846e270d8f8c635a51489cfebd9de8ee407b1d917de8a570f16571"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comderailedpopeyecmd.version=#{version}
      -X github.comderailedpopeyecmd.commit=#{tap.user}
      -X github.comderailedpopeyecmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"popeye", "completion")
  end

  test do
    output = shell_output("#{bin}popeye --save --out html --output-file report.html 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}popeye version")
  end
end