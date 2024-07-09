class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https:temporal.io"
  url "https:github.comtemporaliocliarchiverefstagsv0.13.2.tar.gz"
  sha256 "a492f79b2b9e2429fcce6674cd7a197fab69cc2e4f19201ddc2ea7367dbab1fd"
  license "MIT"
  head "https:github.comtemporaliocli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b227f8933bb196c685e4cbac92bb91e70f8c595bb1a8eebb74306a632925993"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3df1ac8326d65cfb0de8fd91a8f042499f5600786d4b8b67a25487f983bddefc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a590231c7805c0bf7d1729dcab753c28bec2872188573512d7e39675b472a1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e28e9c27b2e24501fd9479dd79d90d6571104497198858dd088cab6c5828ee4"
    sha256 cellar: :any_skip_relocation, ventura:        "28fa2ee8abc9dca2abbbbfe97f713d9054440c75de99e2fdd6d1e529732f9f9f"
    sha256 cellar: :any_skip_relocation, monterey:       "6b6f675b455017ac602b46df5bc5b401cd83638a947807f973b420452f371a7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ceeeac0283e22c59a5aa299a8d7c0581e5c820f44d866dd1163aa634b164743"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comtemporalioclitemporalcli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdtemporal"
    generate_completions_from_executable bin"temporal", "completion"
  end

  test do
    run_output = shell_output("#{bin}temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end