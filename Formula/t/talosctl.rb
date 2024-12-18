class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https:www.talos.dev"
  url "https:github.comsiderolabstalosarchiverefstagsv1.9.0.tar.gz"
  sha256 "3f7817e990d56247832750ed0acc4af6199192786fc2396c2dc7a03f4af8534e"
  license "MPL-2.0"
  head "https:github.comsiderolabstalos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "425e31eef38acf57141b7ad866cc8bd0dfa888ddae281606f16534496d2692ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc527e5e2f36a13f5f0d081694856860cd3584b292f42b8c0d7a282e7b6534a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df774d367cab44308dc1f39262034452cdc0913a6f77ed584fd018e5e2f3fbc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2468e1dee265ae88a42c6c9da64fefc16738453074e1e9f4f677c39e69074c6e"
    sha256 cellar: :any_skip_relocation, ventura:       "ca911fc5a9dde1160255769c2730f18c8fba144d4a2da1845be47efb35bd8633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abc27c8ed12d035a3b485d564494e6f96ac397ae1e3d6ea1d1fb3653f54af46b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comsiderolabstalospkgmachineryversion.Tag=#{version}
      -X github.comsiderolabstalospkgmachineryversion.Built=#{time.iso8601}

    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdtalosctl"

    generate_completions_from_executable(bin"talosctl", "completion")
  end

  test do
    # version check also failed with `failed to determine endpoints` for server config
    assert_match version.to_s, shell_output("#{bin}talosctl version 2>&1", 1)

    output = shell_output("#{bin}talosctl list 2>&1", 1)
    assert_match "error constructing client: failed to determine endpoints", output
  end
end