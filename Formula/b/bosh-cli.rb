class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://ghfast.top/https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.10.8.tar.gz"
  sha256 "ffc6a347f60a8512fbdd6bf6b90044d4c1e115157c03318d6b50ff7cc0d51799"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe5eb4a539230e13547fe4154c10ca2f7db1921a277b63ffeb78f3de6a3ae7b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe5eb4a539230e13547fe4154c10ca2f7db1921a277b63ffeb78f3de6a3ae7b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe5eb4a539230e13547fe4154c10ca2f7db1921a277b63ffeb78f3de6a3ae7b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8547dcbd0256f6e99f21567a63d2780e55baab964030463ae145d93e3b9d9a5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96f54ac6a73405d3da7c9704b317d0934735b0b3b2c4f21dfbd6f493242c8930"
    sha256 cellar: :any,                 x86_64_linux:  "826976cd0e9341116efa105c09899dcb9daef8d0937bfb52fdc97c67f2b615ea"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"bosh-cli", shell_parameter_format: :cobra)
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end