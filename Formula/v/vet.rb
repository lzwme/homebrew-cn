class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https:github.comsafedepvet"
  url "https:github.comsafedepvetarchiverefstagsv1.8.3.tar.gz"
  sha256 "8ba353011f216b2b45ceccaf1cfd9251896fd8ba9365bf460b01a87c9ed97fc8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f50445827c0d888976a90b1942b8dd62cc9a887ed44a08b03a1f05b48a72ccc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37561b92720e54759edc886608504880004607c82ad46f21a8f9102b9efe4eb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13674ab3d2722785822b1e866d3cff8f702be375eea88a6a60fc21f013e33b64"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b52ae36d093e5a09b5027fbc2c73722b4c98d49487d61dec8a9c98e91d4e3ca"
    sha256 cellar: :any_skip_relocation, ventura:       "4549c4c77b9d2b6539e2ef0070cc16e78f1a98f49f4e10b1801e324fc2a9246f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6abb6faf1b89054f4309dffb54e644ade9b036ffeb6a8e24c6fb2a1276eca168"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vet version 2>&1", 1)

    output = shell_output("#{bin}vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end