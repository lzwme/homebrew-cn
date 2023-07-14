class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://ghproxy.com/https://github.com/FairwindsOps/pluto/archive/v5.18.1.tar.gz"
  sha256 "dc78c2c688e8e17418e3ab6c771cc33b45ada5e8d89394f1cb0dfae4e9d1713e"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce271f59eb3075e2e4520400e161a3bc7b31d1a947ff9fb382fa4190c4670941"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce271f59eb3075e2e4520400e161a3bc7b31d1a947ff9fb382fa4190c4670941"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce271f59eb3075e2e4520400e161a3bc7b31d1a947ff9fb382fa4190c4670941"
    sha256 cellar: :any_skip_relocation, ventura:        "7e24abb3cea9cedf0769e33b56d57ca26deb1fb4f5a0b0dc3f8f21efa4468fda"
    sha256 cellar: :any_skip_relocation, monterey:       "7e24abb3cea9cedf0769e33b56d57ca26deb1fb4f5a0b0dc3f8f21efa4468fda"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e24abb3cea9cedf0769e33b56d57ca26deb1fb4f5a0b0dc3f8f21efa4468fda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc22ed107df3f07baf35131411eb703bccf2eeb32c32467febf77b4d1b006b54"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags: ldflags), "cmd/pluto/main.go"
    generate_completions_from_executable(bin/"pluto", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pluto version")
    assert_match "Deployment", shell_output("#{bin}/pluto list-versions")

    (testpath/"deployment.yaml").write <<~EOS
      apiVersion: extensions/v1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    EOS
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml")
  end
end