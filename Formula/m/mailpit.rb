class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https:mailpit.axllent.org"
  url "https:github.comaxllentmailpitarchiverefstagsv1.21.5.tar.gz"
  sha256 "d3eb50f50dbaca546fb22206eb009757628109f1afdfce98e2586157ce620c6a"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bf773cc6e2a52d46e04a4c20e74c78e3511973b10c948baea59afe9798fa5f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f317f2869ebbfedb25257ecfac26b0a42cae10f0f2004d8af30658ef8b7a1941"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f836c6b150732e2c9e1f54fc1fd4bb5a6ca07050557749eb61f405edbcecd787"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a038cacb8c688c3f51522e24a463c0e4358c76ca767126ab840896d99ff5d6f"
    sha256 cellar: :any_skip_relocation, ventura:       "016e99703569133f8bee3b8b97090e372b2bf77ed7797ae854dbb7638297c15d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3d37c221c7392d518c2648f4df4f446807083ba7ff65c522e4a76cb04917b02"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    ldflags = "-s -w -X github.comaxllentmailpitconfig.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"mailpit", "completion")
  end

  service do
    run opt_bin"mailpit"
    keep_alive true
    log_path var"logmailpit.log"
    error_log_path var"logmailpit.log"
  end

  test do
    (testpath"test_email.txt").write "wrong format message"

    output = shell_output("#{bin}mailpit sendmail < #{testpath}test_email.txt 2>&1", 11)
    assert_match "error parsing message body: malformed header line", output

    assert_match "mailpit v#{version}", shell_output("#{bin}mailpit version")
  end
end