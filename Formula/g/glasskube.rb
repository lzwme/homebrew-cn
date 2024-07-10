class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.13.0.tar.gz"
  sha256 "765c586d068917fc20e48bb5d8495697db6197fb11792a5e133342a2fc217144"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f08737660fee98fcfc5b44047746df3b93667abc620fa09b20aa8fc3873adb1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73fe2be49783a2d3d86bab3d7f5d77bdd5c522b4104552b9ae9b45a3f2415937"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd5a36179a58eb532f0b58e18c8f57a27a789748e94496f621a66331630377f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "cfb9ca17510560f0dd6d019348d506d53fe74e85c8de4aeed2d1720882981336"
    sha256 cellar: :any_skip_relocation, ventura:        "be0036f28955adf035fa582991b912f2c004863bb187012ea30228a50d55ba65"
    sha256 cellar: :any_skip_relocation, monterey:       "73fd46491f716fb33bfbe5cc6e3844d6ff3e092694b75580c4e96eb7a60f8445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18220acab635b8eabe80e9f88871135196e52b0d8ceb011166d659a7bf4c0fc5"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comglasskubeglasskubeinternalconfig.Version=#{version}
      -X github.comglasskubeglasskubeinternalconfig.Commit=#{tap.user}
      -X github.comglasskubeglasskubeinternalconfig.Date=#{time.iso8601}
    ]

    system "make", "web"
    system "go", "build", *std_go_args(ldflags:), ".cmdglasskube"

    generate_completions_from_executable(bin"glasskube", "completion")
  end

  test do
    output = shell_output("#{bin}glasskube bootstrap --type slim 2>&1", 1)
    assert_match "Your kubeconfig file is either empty or missing!", output

    assert_match version.to_s, shell_output("#{bin}glasskube --version")
  end
end