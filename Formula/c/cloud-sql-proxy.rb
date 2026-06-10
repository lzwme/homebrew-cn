class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://ghfast.top/https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.22.1.tar.gz"
  sha256 "dcc25ef38aa29bdaee6484a68d9e92630f9f39eae674caff1c018e42af93dc62"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e901b9416c13fc3ebedc2d670232c6029ced9fc8597d81b7a492de79dc5d93d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a04c0e46cd5d1b3b8beef65e099cee51320edcbfe2efe6ad840945aa1dcc793"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58b8259bd76c547c9fdfbe4913fc77e3a1cf144bb097c63b78979091e7297e1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "86ff003fa80a0925a54bdfe7fa27d7c02bab438d7f9f891a41f6dbbef85d74a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2feb3fadb758c1b1c53e7210c2f64b98b90bbbf8d87796b50a3f8dd1a1c85ca8"
    sha256 cellar: :any,                 x86_64_linux:  "1f1473f5b74885cd72edf1529cadee8eef02ab8693106e04c7237150963ed607"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cloud-sql-proxy", shell_parameter_format: :cobra)
  end

  test do
    assert_match "cloud-sql-proxy version #{version}", shell_output("#{bin}/cloud-sql-proxy --version")
    assert_match "could not find default credentials", shell_output("#{bin}/cloud-sql-proxy test 2>&1", 1)
  end
end