class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https:www.greenmask.io"
  url "https:github.comGreenmaskIOgreenmaskarchiverefstagsv0.2.9.tar.gz"
  sha256 "81d5779564adb330d76ed526f89f00d592a3f477888e0402e649958814f65a5a"
  license "Apache-2.0"
  head "https:github.comGreenmaskIOgreenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f18835ae9e7674925f5fcb62821268418ee147653b92df3c14426d1c0b7f124b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f18835ae9e7674925f5fcb62821268418ee147653b92df3c14426d1c0b7f124b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f18835ae9e7674925f5fcb62821268418ee147653b92df3c14426d1c0b7f124b"
    sha256 cellar: :any_skip_relocation, sonoma:        "97834ed1e07c07a171f718560710ca0e53ed6809f7859f323754cd64258c7db4"
    sha256 cellar: :any_skip_relocation, ventura:       "97834ed1e07c07a171f718560710ca0e53ed6809f7859f323754cd64258c7db4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6871feb43cbda9dc0829cf7c963240887efb724c9edfcc786885ac5c10b7af6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgreenmaskiogreenmaskcmdgreenmaskcmd.Version=#{version}
    ]
    system "go", "build", "-tags=viper_bind_struct", *std_go_args(ldflags:), ".cmdgreenmask"

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