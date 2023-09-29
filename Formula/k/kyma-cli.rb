class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://ghproxy.com/https://github.com/kyma-project/cli/archive/2.18.2.tar.gz"
  sha256 "e833f19d6ddf25de2fd7f0e7a3674a92e82600f55d90b936d1d7910b2a681309"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62b9424dbceb19f5317d8b57ca65a782ace7adea3a1a7d309891e5d26c921d50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df6fd78d75258d02f8e6da6f1b9f64b488402e61999f84f5ea636afb6b6cc4e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6bc5ea093336b277979add0c710e070ff66f04186e1834b3b06139b030fceab"
    sha256 cellar: :any_skip_relocation, sonoma:         "50f0fb0cdb447305674a973b93e2e537653025d43edcd7e31c579176d188dd7b"
    sha256 cellar: :any_skip_relocation, ventura:        "a82e68843e249efdd26914a59d20fbff27816c17f982a61639422d0c96e2f4f9"
    sha256 cellar: :any_skip_relocation, monterey:       "057f0c3c329dd90d77481a9c5f63b093cea4a1bc0c31d88159b921ba26b700a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55b3f138487dcc73b584363c494a7086fbb1a3b9776f8e5723a4cf4ae7105c60"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags: ldflags), "./cmd"

    generate_completions_from_executable(bin/"kyma", "completion", base_name: "kyma")
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma deploy --kubeconfig ./kubeconfig 2>&1", 2)

    assert_match "Kyma CLI version: #{version}", shell_output("#{bin}/kyma version 2>&1", 2)
  end
end