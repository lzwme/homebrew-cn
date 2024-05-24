class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https:glasskube.dev"
  url "https:github.comglasskubeglasskubearchiverefstagsv0.6.0.tar.gz"
  sha256 "34444ea5f216479c8bf3ee72487405f3877dd425dd0ca7846e90da11ead8b55f"
  license "Apache-2.0"
  head "https:github.comglasskubeglasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57c5cb209608dec9bb22fe2ea85009c961eabf3c5ae7a15cd3d02fb5d16fc96c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dc7e3a1c59c73ca267cc123b6198bd5e662d54501c43bc55f2dcaf92e7b6b0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76ea6c2a32f306457506ef488c3f773a5025e108c227cd53e7d20af98a117adc"
    sha256 cellar: :any_skip_relocation, sonoma:         "0915ad8a3a734d514dfc3bf415675cefd1e7435783677a243380bc04cd1c2f1f"
    sha256 cellar: :any_skip_relocation, ventura:        "e495555342959a0113ae694b84839590b1e0d0023ceecddb3f41c3dd6fed91f6"
    sha256 cellar: :any_skip_relocation, monterey:       "41b407eea77872f62b1db2f4637f639196dae2ffff2bc9a3191b4f4864d943da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31ac9614a12641cc80ecb5df8eb3cfa265d7382e5478ded364c089919ded86af"
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