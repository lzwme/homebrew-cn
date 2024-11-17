class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https:greenmask.io"
  url "https:github.comGreenmaskIOgreenmaskarchiverefstagsv0.2.5.tar.gz"
  sha256 "27545ab02f9fd363c0eb908f723d9bd358457ccd8c0df4fa7cf1d0c5262302c9"
  license "Apache-2.0"
  head "https:github.comGreenmaskIOgreenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c73ac6edebd08fb3bb0887f714ba11f28d4b4d7024043e6526e87466d356739d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c73ac6edebd08fb3bb0887f714ba11f28d4b4d7024043e6526e87466d356739d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c73ac6edebd08fb3bb0887f714ba11f28d4b4d7024043e6526e87466d356739d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c828aca51842b4a5c9e755e87453a37f9f8e1628eadd257375be7496022f906"
    sha256 cellar: :any_skip_relocation, ventura:       "8c828aca51842b4a5c9e755e87453a37f9f8e1628eadd257375be7496022f906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11e62468e28d4e0b7920920cb5793bdec31304fff6c359ef569a6251d7b058de"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgreenmaskiogreenmaskcmdgreenmaskcmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdgreenmask"

    generate_completions_from_executable(bin"greenmask", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}greenmask -v")

    (testpath"config.yml").write <<~YAML
      common:
        pg_bin_path: "usrlibpostgresql16bin"
        tmp_dir: "tmp"

      storage:
        s3:
          endpoint: "http:playground-storage:9000"
          bucket: "adventureworks"
          region: "us-east-1"
          access_key_id: "Q3AM3UQ867SPQQA43P2F"
          secret_access_key: "zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG"

      validate:
      #  resolved_warnings:
      #    - "aa808fb574a1359c6606e464833feceb"

      dump:
        pg_dump_options: # pg_dump option that will be provided
          dbname: "host=playground-db user=postgres password=example dbname=original"
          jobs: 10

        transformation: # List of tables to transform
          - schema: "humanresources" # Table schema
            name: "employee"  # Table name
            transformers: # List of transformers to apply
              - name: "NoiseDate" # name of transformers
                params: # Transformer parameters
                  ratio: "10 year 9 mon 1 day"
                  column: "birthdate" # Column parameter - this transformer affects scheduled_departure column

      restore:
        pg_restore_options: # pg_restore option (you can use the same options as pg_restore has)
          jobs: 10
          dbname: "host=playground-db user=postgres password=example dbname=transformed"
    YAML

    output = shell_output("#{bin}greenmask --config config.yml list-transformers")
    assert_match "Generate UUID", output
    assert_match "Generates a random word", output
  end
end